USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[TERMS_SDLL]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[TERMS_SDLL]  @parm1 varchar (2)   as
select descr from TERMS
where    termsid    =    @parm1
order by termsid
GO
