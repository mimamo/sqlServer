USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvs_xASetupLog]    Script Date: 12/21/2015 16:00:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[xvs_xASetupLog] (AID, ASolomonUserID, ADate, ATime, AProcess, DB, Module, TableName, TableDescr, tstamp)ASSelect a.AID, a.ASolomonUserID, a.ADate, a.ATime, a.AProcess, CONVERT(Char(3), 'App') AS DB, a.Module, a.TableName, b.TableDescr, a.tstamp From xASetupLog a Left Join xATABLES b On a.TableName = b.TableNameUnion AllSelect a.AID, a.ASolomonUserID, a.ADate, a.ATime, a.AProcess, CONVERT(Char(3), 'Sys') AS DB, a.Module, a.TableName, b.TableDescr, a.tstamp From DENVERSYS.dbo.xASetupLog a Left Join DENVERSYS.dbo.xATABLES b On a.TableName = b.TableName
GO
