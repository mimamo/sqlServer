USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Open_Rlsed]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Open_Rlsed    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_Open_Rlsed] As
 Select * from ARDoc WHERE
    doctype IN ('FI', 'IN', 'DM', 'CM')
    and ARDoc.OpenDoc = 1
    and Rlsed = 1
    order by DocType, RefNbr
GO
