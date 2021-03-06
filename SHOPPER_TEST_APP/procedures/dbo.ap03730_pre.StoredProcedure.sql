USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ap03730_pre]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ap03730_pre    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[ap03730_pre] @RI_ID smallint AS

        DECLARE @gl_setupid     char(2),
                @ap_setupid     char(2)


        ---  Get the GL and AP Setup ids for linking in the report

        SELECT  @gl_setupid = max(SetupID)
        FROM    glsetup

        SELECT  @ap_setupid = max(SetupID)
        FROM    apsetup


        ---  Remove old records if any

        DELETE  FROM ap03730_wrk
        WHERE   RI_ID = @RI_ID


        ---  Update the where clause with the ri_id

        EXEC    SetRIWhere_sp   @ri_id, 'ap03730_wrk'


        ---  Insert a list of 1099 vendors
        ---  into the report temporary table

        INSERT  ap03730_wrk
        SELECT  @RI_ID,
                VendID,
                @gl_setupid,
                @ap_setupid,
                NULL
        FROM    Vendor
        WHERE   Vend1099 = 1
GO
