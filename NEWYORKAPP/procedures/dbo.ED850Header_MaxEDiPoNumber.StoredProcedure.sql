USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_MaxEDiPoNumber]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Header_MaxEDiPoNumber]  AS
 Select max(edipoid) from ed850header
GO
