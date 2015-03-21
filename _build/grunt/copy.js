module.exports = {
  js: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/js',
      src:['**/*.js'],
      dest: '<%= config.dir.tmp %>/js'
    }]
  },
  jsProd: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/js/',
      src:['**/*.js'],
      dest: '<%= config.dir.dist %>/js/'
    }]
  },
  img: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/img',
      src:['**/*'],
      dest: '<%= config.dir.tmp %>/img'
    }]
  },
  imgProd: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/img',
      src:['**/*'],
      dest: '<%= config.dir.dist %>/img'
    }]
  },
  audio: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/audio',
      src:['**/*'],
      dest: '<%= config.dir.tmp %>/audio'
    }]
  },
  audioProd: {
    files: [{
      expand: true,
      cwd: '<%= config.dir.src %>/audio',
      src:['**/*'],
      dest: '<%= config.dir.dist %>/audio'
    }]
  }
};
