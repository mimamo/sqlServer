USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_PCPR_pjptdsum]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_PCPR_pjptdsum]  @project varchar(16), @pjt_entity varchar(32), @acct varchar(16) as      
select * from pjptdsum where 
project = @project
and pjt_entity = @pjt_entity
and acct = @acct
order by project
GO
