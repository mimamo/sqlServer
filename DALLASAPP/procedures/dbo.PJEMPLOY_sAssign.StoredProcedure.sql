USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sAssign]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sAssign] @parm1 varchar (10) as
select *
From PJEMPLOY
Where PJEMPLOY.employee like @parm1 and
     ((PJEMPLOY.emp_status = 'A')
      or
	 (PJEMPLOY.emp_status = 'I' and PJEMPLOY.Placeholder = 'Y' ))
GO
