USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_10550_Delete]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pp_10550_Delete]
            @UserAddress VARCHAR (21) As       -- ComputerName
-- Purge Work Records
    DELETE FROM IN10550_Wrk
          WHERE ComputerName = @UserAddress
GO
