# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class SignaturesController < ApplicationController
  def summary

    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      order = 'sig_id'
    end

  
    @summary_pager = Pager.new(Signature.count, params[:page])

    @signatures    = Signature.find(:all,
                                    :limit  => @summary_pager.per_page,
                                    :offset => @summary_pager.offset, 
                                    :order  => order) 
  end

  def detail 
    @order     = params[:order] || 'timestamp'
    @signature = Signature.find(params[:id])
    @pager     = Pager.new(@signature.events.count, params[:page])
    @events    = @signature.events.find(:all, 
                                        :limit  => @pager.per_page,
                                        :offset => @pager.offset,
                                        :order  => @order)
  end

end
