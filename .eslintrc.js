module.exports = {
 extends: [
  "plugin:yml/standard",
 ],
 rules: {
  "yml/no-empty-mapping-value": "off",
  "yml/plain-scalar": "off",
 },
 overrides: [
  {
   files: ["*.yaml", "*.yml"],
   parser: "yaml-eslint-parser",
  },
 ],
}