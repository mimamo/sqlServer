USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_Sspv]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_Sspv] @parm1 varchar (10) , @parm2 varchar (10)   as
select * from PJLABHDR
where    employee like @parm1 and
Docnbr Like @parm2 and
le_status <> 'X'
order by employee, docnbr desc, le_type, pe_date desc
GO
