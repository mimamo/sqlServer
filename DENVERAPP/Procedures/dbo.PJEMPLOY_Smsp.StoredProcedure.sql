USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_Smsp]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_Smsp] as
select * from PJEMPLOY
where emp_status = 'A' and
	MSPInterface <> 'Y'
order by employee
GO
