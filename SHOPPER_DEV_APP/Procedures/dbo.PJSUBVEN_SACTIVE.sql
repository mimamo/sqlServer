USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBVEN_SACTIVE]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBVEN_SACTIVE] @parm1 varchar (15)  as
select * from PJSUBVEN
where vendid =    @parm1
and status =    'A'
order by vendid
GO
