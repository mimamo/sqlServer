USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_Spk92]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_Spk92] @parm1 varchar (10) , @parm2 varchar (30)   as
select * from PJLABHDR
where    employee  =    @parm1 and
le_Key    =    @parm2
order by employee, docnbr desc, le_type, pe_date desc
GO
