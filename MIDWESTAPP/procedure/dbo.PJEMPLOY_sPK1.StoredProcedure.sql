USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sPK1]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sPK1] @parm1 varchar (10)  as
select * from PJEMPLOY
where EMPLOYEE like @parm1
order by employee
GO
