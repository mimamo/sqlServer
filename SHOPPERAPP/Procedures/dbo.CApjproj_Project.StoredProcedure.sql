USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CApjproj_Project]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[CApjproj_Project] @Parm1 Varchar(16) as
select * from PJPROJ where project like @parm1 and status_pa = 'A'  order by project
GO
