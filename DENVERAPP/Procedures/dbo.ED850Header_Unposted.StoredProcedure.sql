USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_Unposted]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_Unposted] As select * from ED850Header where UpdateStatus = 'OK' Order By EDIPOID
GO
