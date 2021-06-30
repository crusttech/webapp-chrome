<template>
  <main>
    {{ $t('application') }} (<code>{{ $route.path }}</code>) {{ $t('notFound') }}
  </main>
</template>

<script>
import i18n from '../i18n'

export default {
  i18nOptions: {
    keyPrefix: 'noApp',
  },
  data () {
    return {}
  },
  i18n: i18n(),
}
</script>
<style lang="scss">
main {
  margin: 40px;
  text-align: center;
  width: 100%;
}
</style>
