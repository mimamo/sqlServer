USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSITE_sAll]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJSITE_sAll] @parm1 varchar (4)  as
select * from PJSITE
where TerminalCode like @parm1
order by TerminalCode
GO
