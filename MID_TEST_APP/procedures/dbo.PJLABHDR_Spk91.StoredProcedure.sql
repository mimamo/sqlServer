USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_Spk91]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_Spk91] @parm1 varchar (10) , @parm2 varchar (10)   as
select * from PJLABHDR
where    employee  =    @parm1 and
Docnbr    Like @parm2 and
le_Status =    'P'
order by employee, docnbr desc, le_type, pe_date desc
GO
