USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGH_SI01]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGH_SI01] @parm1 varchar (6)   as
select Count(*) from PJCHARGH
where   FiscalNo = @parm1 and
Batch_Status <> 'P'
GO
