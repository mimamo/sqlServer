USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xRetailCustomer_pv]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xRetailCustomer_pv](
@parm1 char(30)
)

AS


SELECT rCustID, rCustName FROM xRetailCustomer WHERE rCustID like LTRIM(RTRIM(@parm1)) and Status = 'A' ORDER BY rCustID
GO
