USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Cpnyid_ShipperId]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Created by Will Byron CEPSystems 5/11/99
CREATE PROCEDURE [dbo].[EDContainer_Cpnyid_ShipperId] @parm1 varchar(10), @parm2 varchar(15)  AS
Select * from EDContainer
Where Cpnyid like @parm1 and
ShipperID like @parm2
Order BY Shipperid
GO
