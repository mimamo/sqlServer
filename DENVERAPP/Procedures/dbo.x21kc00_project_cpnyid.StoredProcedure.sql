USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc00_project_cpnyid]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc00_project_cpnyid]   @from as varchar(16), @to varchar(16) as
select count(*) from pjproj P1, pjproj P2
where P1.project  = @from
and P2.project = @to
and P1.cpnyid <> P2.cpnyid
GO
