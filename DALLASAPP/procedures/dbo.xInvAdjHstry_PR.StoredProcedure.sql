USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xInvAdjHstry_PR]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xInvAdjHstry_PR] 
AS
Select pjinvhdr.* from xInvAdjHstry,pjinvhdr where 
xInvAdjHstry.TYPE = 'PR' 
AND xInvAdjHstry.Project_billwith = pjinvhdr.Project_billwith 
and xInvAdjHstry.Draft_num = pjinvhdr.Draft_num
GO
