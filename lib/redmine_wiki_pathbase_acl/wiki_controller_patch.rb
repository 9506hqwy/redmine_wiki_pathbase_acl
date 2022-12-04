# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module WikiControllerPatch
    def wiki_pathbase_acl_check(permission, &block)
      if Utils.exist_deny_acl?(@project, User.current, permission)
        deny_access
        return
      end

      yield
    end

    def wiki_pathbase_acl_new(&block)
      if request.post? && params[:parent]
        ppage = @wiki.find_page(params[:parent])
        unless Utils.permit_page?(ppage, User.current, :edit_wiki_pages)
          deny_access
          return
        end
      end

      yield
    end

    def wiki_pathbase_acl_preview(&block)
      page = @wiki.find_page(params[:id])
      unless Utils.permit_page?(page, User.current, :edit_wiki_pages)
        deny_access
        return
      end

      yield
    end

    def wiki_pathbase_acl_process(permission, &block)
      unless Utils.permit_page?(@page, User.current, permission)
        deny_access
        return
      end

      yield
    end

    def wiki_pathbase_acl_show(&block)
      unless Utils.permit_page?(@page, User.current, :view_wiki_pages)
        deny_access
        return
      end

      if params[:version] && !Utils.permit_page?(@page, User.current, :view_wiki_edits)
        deny_access
        return
      end

      yield
    end

    def wiki_pathbase_acl_update(&block)
      @page = @wiki.find_or_new_page(params[:id])

      page = @page
      if @page.new_record? && params[:wiki_page][:parent_id].present?
        page = @wiki.pages.find(params[:wiki_page][:parent_id])
      end

      unless Utils.permit_page?(page, User.current, :edit_wiki_pages)
        deny_access
        return
      end

      yield
    end
  end

  module WikiControllerPatch4
    include WikiControllerPatch

    def self.included(base)
      base.class_eval do
        alias_method_chain(:add_attachment, :wiki_pathbase_acl)
        alias_method_chain(:annotate, :wiki_pathbase_acl)
        alias_method_chain(:destroy, :wiki_pathbase_acl)
        alias_method_chain(:destroy_version, :wiki_pathbase_acl)
        alias_method_chain(:diff, :wiki_pathbase_acl)
        alias_method_chain(:edit, :wiki_pathbase_acl)
        alias_method_chain(:export, :wiki_pathbase_acl)
        alias_method_chain(:history, :wiki_pathbase_acl)
        alias_method_chain(:new, :wiki_pathbase_acl)
        alias_method_chain(:preview, :wiki_pathbase_acl)
        alias_method_chain(:protect, :wiki_pathbase_acl)
        alias_method_chain(:rename, :wiki_pathbase_acl)
        alias_method_chain(:show, :wiki_pathbase_acl)
        alias_method_chain(:update, :wiki_pathbase_acl)
      end
    end

    def add_attachment_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:edit_wiki_pages) do
        add_attachment_without_wiki_pathbase_acl
      end
    end

    def annotate_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:view_wiki_edits) do
        annotate_without_wiki_pathbase_acl
      end
    end

    def destroy_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        destroy_without_wiki_pathbase_acl
      end
    end

    def destroy_version_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        destroy_version_without_wiki_pathbase_acl
      end
    end

    def diff_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:view_wiki_edits) do
        diff_without_wiki_pathbase_acl
      end
    end

    def edit_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:edit_wiki_pages) do
        edit_without_wiki_pathbase_acl
      end
    end

    def export_with_wiki_pathbase_acl
      wiki_pathbase_acl_check(:view_wiki_pages) do
        export_without_wiki_pathbase_acl
      end
    end

    def history_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:view_wiki_edits) do
        history_without_wiki_pathbase_acl
      end
    end

    def new_with_wiki_pathbase_acl
      wiki_pathbase_acl_new do
        new_without_wiki_pathbase_acl
      end
    end

    def preview_with_wiki_pathbase_acl
      wiki_pathbase_acl_preview do
        preview_without_wiki_pathbase_acl
      end
    end

    def protect_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:protect_wiki_pages) do
        protect_without_wiki_pathbase_acl
      end
    end

    def rename_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:rename_wiki_pages) do
        rename_without_wiki_pathbase_acl
      end
    end

    def show_with_wiki_pathbase_acl
      wiki_pathbase_acl_show do
        show_without_wiki_pathbase_acl
      end
    end

    def update_with_wiki_pathbase_acl
      wiki_pathbase_acl_update do
        update_without_wiki_pathbase_acl
      end
    end
  end

  module WikiControllerPatch5
    include WikiControllerPatch

    def add_attachment
      wiki_pathbase_acl_process(:edit_wiki_pages) do
        super
      end
    end

    def annotate
      wiki_pathbase_acl_process(:view_wiki_edits) do
        super
      end
    end

    def destroy
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        super
      end
    end

    def destroy_version
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        super
      end
    end

    def diff
      wiki_pathbase_acl_process(:view_wiki_edits) do
        super
      end
    end

    def edit
      wiki_pathbase_acl_process(:edit_wiki_pages) do
        super
      end
    end

    def export
      wiki_pathbase_acl_check(:view_wiki_pages) do
        super
      end
    end

    def history
      wiki_pathbase_acl_process(:view_wiki_edits) do
        super
      end
    end

    def new
      wiki_pathbase_acl_new do
        super
      end
    end

    def preview
      wiki_pathbase_acl_preview do
        super
      end
    end

    def protect
      wiki_pathbase_acl_process(:protect_wiki_pages) do
        super
      end
    end

    def rename
      wiki_pathbase_acl_process(:rename_wiki_pages) do
        super
      end
    end

    def show
      wiki_pathbase_acl_show do
        super
      end
    end

    def update
      wiki_pathbase_acl_update do
        super
      end
    end
  end
end

if ActiveSupport::VERSION::MAJOR >= 5
  WikiController.prepend RedmineWikiPathbaseAcl::WikiControllerPatch5
else
  WikiController.include RedmineWikiPathbaseAcl::WikiControllerPatch4
end
