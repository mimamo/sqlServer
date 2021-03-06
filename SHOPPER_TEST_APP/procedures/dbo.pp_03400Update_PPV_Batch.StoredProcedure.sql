USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_03400Update_PPV_Batch]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_03400Update_PPV_Batch]
                 @UserAddress        VARCHAR(21) AS

/***** File Name: 0384pp_03400Update_PPV_Batch.Sql         *****/
/***** Last Modified by Mike Putnam on 12/07/98 at 4:13 pm *****/

    Update W
           Set W.PPVCount = Case When V.PPVCount > 0 Then 1 Else 0 End
           From WrkRelease_PO W, vp_03400_PPV_Batch_Needed V
           Where W.BatNbr = V.BatNbr
             And W.Module = V.JrnlType
             And W.UserAddress = @UserAddress
GO
