USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_Cpnyid_Cont]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_Cpnyid_Cont]  @parm1 varchar(10), @parm2 varchar(10) AS
Select *
From EDContainerDet
Where Cpnyid like @Parm1 and ContainerID like @Parm2
GO
