USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTTYPE_SALL]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTTYPE_SALL]  @parm1 varchar (4)   as
select * from PJUTTYPE
where    utilization_type Like @parm1
order by utilization_type
GO
