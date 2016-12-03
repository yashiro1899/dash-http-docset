'use strict';

const Sequelize = require('sequelize');
const cheerio = require('cheerio');
const fs = require('fs');
const path = require('path');

const html = path.join(__dirname, 'HTTP.docset/Contents/Resources/Documents/developer.mozilla.org/en-US/docs/Web/HTTP.html');
const $ = cheerio.load(fs.readFileSync(html, 'utf8'));

const TYPES = {
  'Guides:': 'Guides',
  'HTTP headers': 'Option',
  'HTTP request methods': 'Method',
  'HTTP response status codes': 'Constant',
  'CSP directives': 'Directive'
};
const items = $('#quick-links li');

const result = [];
let type;
items.each(function (ignore, el) {
  let caption;
  el = $(el).clone();

  caption = $('strong', el);
  if (caption.length > 0) {
    caption = caption.text().trim();
    if (TYPES[caption]) {
      type = TYPES[caption];
    }
    return null;
  }

  const len = $('ol', el).remove().length;
  caption = el.text().trim();
  if (len > 0) {
    if (TYPES[caption]) {
      type = TYPES[caption];
    }
    return null;
  }

  if (type) {
    const href = $('a', el).attr('href');
    const location = path.join('developer.mozilla.org/en-US/docs/Web', href);
    result.push({
      name: caption,
      type,
      path: location
    });
  }
});

const seq = new Sequelize('', '', '', {
  dialect: 'sqlite',
  storage: path.join(__dirname, 'HTTP.docset/Contents/Resources/docSet.dsidx')
});
const SearchIndex = seq.define('searchIndex', {
  id: {
    autoIncrement: true,
    primaryKey: true,
    type: Sequelize.INTEGER
  },
  name: {
    type: Sequelize.STRING,
    unique: 'compositeIndex'
  },
  type: {
    type: Sequelize.STRING,
    unique: 'compositeIndex'
  },
  path: {
    type: Sequelize.STRING,
    unique: 'compositeIndex'
  }
}, {
  freezeTableName: true,
  timestamps: false
});

SearchIndex.sync().then(function () {
  result.reduce(function (prev, t) {
    return prev.then(function () {
      return SearchIndex.create(t);
    });
  }, Promise.resolve());
});
