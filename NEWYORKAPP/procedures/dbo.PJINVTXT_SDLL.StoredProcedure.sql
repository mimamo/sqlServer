USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVTXT_SDLL]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJINVTXT_SDLL]  @parm1 varchar (10) , @parm2 varchar (1)   as
select z_text from PJINVTXT
where    draft_num  = @parm1
and    text_type  = @parm2
order by draft_num
GO
