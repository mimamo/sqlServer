USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_si10]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_si10] @parm1 varchar (10)  as
select * from PJPROJ
where manager1 = @parm1
order by project
GO
