USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Cpnyid_ContainerID]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_Cpnyid_ContainerID] @parm1 varchar(10), @parm2 varchar(10)  AS
Select * from EDContainer
Where Cpnyid like @parm1 and
ContainerID like @parm2
Order BY ContainerID
GO
