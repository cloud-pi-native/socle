// eslint.config.mjs
import antfu from "@antfu/eslint-config"

export default antfu({
  stylistic: {
    indent: 2,
    quotes: "double",
  },
  yaml: {
    overrides: {
      "yml/plain-scalar": "off",
    },
  },
  ignores: ["operator/", "gitops/"],
})
