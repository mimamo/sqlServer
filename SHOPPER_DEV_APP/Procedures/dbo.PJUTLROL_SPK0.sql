USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTLROL_SPK0]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTLROL_SPK0] @parm1 varchar (10) , @parm2 varchar (6), @parm3 varchar (4)      as
select * from PJUTLROL
where employee =  @parm1 and
fiscalno = @parm2 and
utilization_type = @parm3
order by employee, fiscalno, utilization_type
GO
