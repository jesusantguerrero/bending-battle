module.exports = {
  mode: 'jit',
  purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        'fire': {
          DEFAULT: '#5E0600',
          '50': '#FF5045',
          '100': '#FF392B',
          '200': '#F71000',
          '300': '#C40D00',
          '400': '#910900',
          '500': '#5E0600',
          '600': '#2B0300',
          '700': '#000000',
          '800': '#000000',
          '900': '#000000'
        },
        'fire-map': {
          DEFAULT: '#C96D3E',
          '50': '#FBF5F1',
          '100': '#F6E6DD',
          '200': '#EAC7B6',
          '300': '#DFA98E',
          '400': '#D48B66',
          '500': '#C96D3E',
          '600': '#A6572E',
          '700': '#7E4223',
          '800': '#562D18',
          '900': '#2E180D'
        },
        'roti': {
          DEFAULT: '#CDAB4E',
          '50': '#FFFFFF',
          '100': '#FAF6ED',
          '200': '#EFE4C5',
          '300': '#E3D19E',
          '400': '#D8BE76',
          '500': '#CDAB4E',
          '600': '#B59233',
          '700': '#8D7228',
          '800': '#65521D',
          '900': '#3E3211'
        },
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
}
