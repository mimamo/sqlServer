USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sFiscal]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sFiscal] @parm1 varchar (6)  as
select * from PJTRAN
WHERE
fiscalno >= @Parm1
GO
