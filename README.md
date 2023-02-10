# Org Babel support for YAML

The Elisp module `ob-yaml.el` adds support for YAML source code blocks in Org Babel. It was created via trivial modifications of the [template file](https://git.sr.ht/~bzg/worg/tree/master/item/org-contrib/babel/ob-template.el).

The primary aim was to allow for writing and maintaining bigger YAML files (or sets of such files) in a [literate programming](https://en.wikipedia.org/wiki/Literate_programming) style by using the powerful Babel subsystem of [Org mode](https://orgmode.org). One particular example are [Home Assistant](https://www.home-assistant.io) configuration files.

Only a subset of Org Babel functionality is required for such purposes, namely editing blocks in [yaml-mode](https://www.emacswiki.org/emacs/YamlMode), tangling (including [noweb references](https://orgmode.org/manual/Noweb-Reference-Syntax.html)) and possibly exporting. Specifically, YAML blocks needn't be evaluated, and so evaluation-related functions are left unimplemented.
