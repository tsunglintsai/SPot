//
//  TagTVC.m
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "TagTVC.h"

@interface TagTVC ()
@property (nonatomic,strong) NSArray *orderedTagNames; // list of nsstring tag name
@end

@implementation TagTVC

- (void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void) setTagList:(NSDictionary *)tagList{
    _tagList = [tagList copy];
    self.orderedTagNames = [_tagList allKeys];
    self.orderedTagNames = [self.orderedTagNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderedTagNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self titleForRow:indexPath.row]capitalizedString];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    return cell;
}

- (NSString*) titleForRow:(NSUInteger)row{
    return [[self.orderedTagNames objectAtIndex:row]description];
}

- (NSString *) subtitleForRow:(NSUInteger)row{
    int photoCount = [[self.tagList objectForKey:[self.orderedTagNames objectAtIndex:row]]count];
    return  [@[ @(photoCount) , photoCount==1 ? @"photo" : @"photos" ] componentsJoinedByString:@" "];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Push To Photo List"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSArray *photos = [self.tagList objectForKey:[self.orderedTagNames objectAtIndex:[self.tableView indexPathForCell:sender].item]];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
                    [segue.destinationViewController setTitle:[[self titleForRow:indexPath.row]capitalizedString]];
                }
                if([segue.destinationViewController isKindOfClass:[FlickrPhotoTVC class]]){
                    FlickrPhotoTVC *flickrPhotoTVC = segue.destinationViewController;
                    flickrPhotoTVC.delegate = self;
                }
            }
        }
    }
}

- (void)refreshContent:(FlickrPhotoTVC*)sender{
    // abstract
}

@end
