USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xsp_xATABLES_Modules]    Script Date: 12/21/2015 16:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xsp_xATABLES_Modules]WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'ASSelect Distinct xvs_xATABLES.Module, vs_Modules.ModuleName From xvs_xATABLES Left Join vs_Modules On xvs_xATABLES.Module = vs_Modules.ModuleID Where xvs_xATABLES.AuditTable ='T' Order By Module
GO
