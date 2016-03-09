USE [DEN_DEV_SYS]
GO

/****** Object:  StoredProcedure [dbo].[pvrec_all]    Script Date: 03/04/2016 10:30:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[pvrec_all] @parm1 varchar ( 30) as
    select * from PVRec where PVRec.PVId like @parm1
    order by PVId 

GO


