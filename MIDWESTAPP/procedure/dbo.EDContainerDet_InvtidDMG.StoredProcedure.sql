USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_InvtidDMG]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDContainerDet_Invtid    Script Date: 5/28/99 1:17:40 PM ******/
CREATE PROCEDURE [dbo].[EDContainerDet_InvtidDMG] @parm1 varchar(10) AS
Select Distinct Invtid
From EDContainerDet
Where ContainerID like @Parm1
GO
