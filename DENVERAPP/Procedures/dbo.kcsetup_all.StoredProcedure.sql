USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[kcsetup_all]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[kcsetup_all]   as
SELECT * from kcsetup 
order by setupid
GO
