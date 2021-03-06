USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_ltexp]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJLABHDR_ltexp]  @parm1 varchar (6) , @parm2 smalldatetime   as
select * from PJLABHDR, PJLABDIS, PJEMPLOY
where
pjlabhdr.docnbr = pjlabdis.docnbr and
pjlabhdr.le_status in ('P','X') and
pjlabdis.status_1 = ' ' and
pjlabdis.status_2 <> 'P' and
pjlabhdr.employee = pjemploy.employee and
pjlabhdr.fiscalno = @parm1 and
pjlabdis.pe_date <= @parm2
Order by
pjlabhdr.docnbr
GO
