USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvs_xATABLES]    Script Date: 12/21/2015 15:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[xvs_xATABLES] (Module, TableDescr, TableName, AddTable, RemoveTable, AuditTable, InitialData, IndexName, tstamp)ASSelect  *  From xATABLESUnion AllSelect  *  From DENVERSYS.dbo.xATABLES
GO
