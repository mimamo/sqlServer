USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_SI01]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_SI01] @parm1 smalldatetime  as
select  Count(*) from PJLABHDR
where   pe_date <=  @parm1 and
le_Status <> 'P' and
le_Status <> 'X' and
le_type = 'R '
GO
