USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_PCPR_Pjptdrol]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_PCPR_Pjptdrol]  @project varchar(16), @acct varchar(16) as      
select * from pjptdrol where 
project = @project
and acct = @acct
order by project
GO
