import { minify } from 'uglify-js'

const minifyOptions = {
  compress: {
    pure_funcs: [
      'F2',
      'F3',
      'F4',
      'F5',
      'F6',
      'F7',
      'F8',
      'F9',
      'A2',
      'A3',
      'A4',
      'A5',
      'A6',
      'A7',
      'A8',
      'A9',
    ],
    pure_getters: true,
    keep_fargs: false,
    unsafe_comps: true,
    unsafe: true,
  },
  mangle: {
    reserved: ['Elm'],
  },
}

/** @type {import("elm-watch/elm-watch-node").Postprocess} */
export default function postprocess(options) {
  if (
    options.runMode === 'hot' ||
    ['debug', 'standard'].includes(options.compilationMode)
  ) {
    return options.code
  }

  if (options.runMode === 'make' && options.compilationMode === 'optimize') {
    const result = minify(options.code, minifyOptions)

    if (result.error !== undefined) {
      throw new Error(error)
    }

    if (result.warnings !== undefined) {
      for (const warning of warnings) {
        console.warn(`[Warning]: ${warning}`)
      }
    }

    return result.code
  }

  throw new Error(`Unknown compilation mode: ${options.compilationMode}`)
}
