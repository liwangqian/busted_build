
require("utility")

-- 用safe_require替换require，用于解决找不到外部依赖模块的问题
utility.export_api(safe_require, 'require')
