USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vp_10400_ASSYDOC_Validation]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vp_10400_ASSYDOC_Validation]
AS
    Select BATNBR, FIELD = 'CPNYID'
            From AssyDoc 
            Where   DataLength(RTrim(CpnyID)) = 0
    Union
    Select BATNBR, FIELD = 'KITID'
            From AssyDoc
            Where   DataLength(RTrim(KitID)) = 0
    Union
    Select BATNBR, FIELD = 'REFNBR'
            From AssyDoc
            Where   DataLength(RTrim(AssyDoc.RefNbr)) = 0
    Union
    Select BATNBR, FIELD = 'PERPOST'
            From AssyDoc
            Where   DataLength(RTrim(PerPost)) = 0
    Union
    Select BATNBR, FIELD = 'SITEID'
            From AssyDoc
            Where   DataLength(RTrim(AssyDoc.SiteID)) = 0
    Union
    Select BATNBR, FIELD = 'SPECIFICCOSTID'
            From AssyDoc Join Inventory
		On AssyDoc.KitID = Inventory.InvtID
            Where	(DataLength(RTrim(AssyDoc.SpecificCostID)) = 0
			And Inventory.ValMthd = 'S')
    Union
    Select BATNBR, FIELD = 'WHSELOC'
            From AssyDoc
            Where   DataLength(RTrim(AssyDoc.WhseLoc)) = 0
GO
