USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGH_SI01]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGH_SI01] @parm1 varchar (6)   as
select Count(*) from PJCHARGH
where   FiscalNo = @parm1 and
Batch_Status <> 'P'
GO
