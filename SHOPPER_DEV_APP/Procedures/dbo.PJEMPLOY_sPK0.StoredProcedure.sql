USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sPK0]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sPK0] @parm1 varchar (10)  as
select * from PJEMPLOY
where EMPLOYEE = @parm1
order by employee
GO
