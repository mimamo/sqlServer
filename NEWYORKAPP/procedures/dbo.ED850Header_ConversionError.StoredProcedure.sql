USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_ConversionError]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_ConversionError] As
Select * From ED850Header Where UpdateStatus = 'CE'
GO
