USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sAssignAll]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sAssignAll] @parm1 varchar (10) as
select *
From PJEMPLOY
Where PJEMPLOY.employee like @parm1
GO
